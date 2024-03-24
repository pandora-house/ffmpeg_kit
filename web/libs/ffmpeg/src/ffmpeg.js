import { FFmpeg } from '@ffmpeg/ffmpeg';
import { fetchFile, toBlobURL } from '@ffmpeg/util'

export { convertVideo, convertAudio };

const ffmpeg = new FFmpeg();
var loaded = false;

const loadFfmpeg = async () => {
   const baseURL = 'https://unpkg.com/@ffmpeg/core@0.12.6/dist/umd'

   ffmpeg.on("log", ({ type, message }) => {
      console.log(type, message);
   })

   loaded = await ffmpeg.load(
      {
         coreURL: await toBlobURL(`${baseURL}/ffmpeg-core.js`, 'text/javascript'),
         wasmURL: await toBlobURL(`${baseURL}/ffmpeg-core.wasm`, 'application/wasm'),
      });
}

loadFfmpeg();

async function convertVideo(rawFile, inputFileName) {
   const outFileName = "output.mp4";

   /// https://trac.ffmpeg.org/wiki/Encode/H.264
   /// -preset ultrafast,superfast,veryfast,faster,fast,medium,low,slower,veryslow,placebo
   /// -crf 0-51
   /// -profile:v high сделал по примеру онлайн конвертера
   /// -map 0 -movflags faststart меняет метаданные mediaDataSize, mediaDataOffset, иначе ios vlc_player не воспроизводит видео
   const command = [
      "-i",
      inputFileName,
      "-profile:v",
      "high",
      "-c:v",
      "libx264",
      "-preset",
      "ultrafast",
      "-crf",
      "36",
      "-map",
      "0",
      "-movflags",
      "faststart",
      outFileName
   ];

   return await baseConverter(rawFile, inputFileName, outFileName, command);
}

// Почему-то с конверсией в м4а возникли проблемы на маке, ios, android. Делаю перевод в мп3
async function convertAudio(rawFile, inputFileName) {
   const outFileName = "output.mp3";

   const command = [
      "-i",
      inputFileName,
      "-c:a",
      "libmp3lame",
      outFileName
   ];

   return await baseConverter(rawFile, inputFileName, outFileName, command);
}

async function baseConverter(rawFile, inputFileName, outFileName, command) {
   if (!loaded) {
      return null;
   }

   const blob = new Blob([rawFile]);

   await ffmpeg.writeFile(inputFileName, await fetchFile(blob));

   const code = await ffmpeg.exec(command);

   if (code != 0) {
      return null;
   }

   const file = await ffmpeg.readFile(outFileName);

   return file.buffer;
}