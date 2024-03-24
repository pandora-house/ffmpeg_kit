const ffmpeg_module = require("./src/ffmpeg");

module.exports.ffmpeg_module = ffmpeg_module

module.exports = {
  convertVideo: (rawFile, inputFileName) => ffmpeg_module.convertVideo(rawFile, inputFileName),
  convertAudio: (rawFile, inputFileName) => ffmpeg_module.convertAudio(rawFile, inputFileName),
};