## ГАЙД КАК СДЕЛАТЬ ЛАБУ С MLPACK

### 1. ставим вижак
тут без меня справитесь

### 2. создаем пустую дирректорию /algs 
 - (!) в конфигах твердо прописано все на название дирректории algs, поэтому очень важно назвать ее именно так 

и открываем ее в вижаке `Фаил` -> `Открыть папку...`

### 3. копируем все файлы из моей репы в вашу /algs
итого в вашей дирректории должны быть:
- `.devcontainer/devcontainer.json`
- `.vscode/tasks.json`
- `Dockerfile`
- `polygon/..` с вашими лабами. можете просто склонировать ваш репо с лабами

### 4. запускам докер.
как поставить докер - сами.

### 5. подключаемся к самому контейнеру
слева снизу в вижаке тыкаете на `><`(ну типо) и нажимаете `Повторно открыть в контейнере` 
ATTENTION!!! КОНТЕЙНЕР ПИИИ**** КАКОЙ ТЯЖЕЛЫЙ И БУДЕТ ОООЧЕНЬ ДОЛГО!!
*лично у меня он собирался 5-7 минут, на винде, соответственно, будет треш как долго. терпите.*

- tip: можете сами собрать контейнер руками `docker build .` и смотреть за процессом

### 6. победа! работаем
если все ок - слева снизу должно быть что-то типо `Контейнер разработки: algs dev container`.
это значит что все ок и вы уже работаете в контейнере на базе `debian:bullseye-slim`.

### -1. запускаем сборку
нажимаем `cmd + shift + P` (не на маке через ctl вроде) и пишем `>Tasks: Run Task`, энтер, выбираем задачу `CC/C++: g++ build with mlpack` (ну или по-старинке руками через терминал)