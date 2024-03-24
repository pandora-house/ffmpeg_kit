Пример https://github.com/maxnemoy/js_example

Для билда предварительно загрузить либу 
npm i @ffmpeg/ffmpeg

Если, что-то изменили в папке `src` или файле `module.js` запускаем билд, который сгенирит файлы в папке `dist`
npx webpack build

Папка `dist` кодгенерация файла из папки `src`(и еще чего-то), в `index.html` в хедерах указываем ссылку
<script src="./libs/ffmpeg/dist/ffmpeg_lib.js"></script>