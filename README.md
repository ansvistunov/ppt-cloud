# ppt-cloud

Необходимое программное обеспечение на машинах студентов:
+ yc

## Установка yc (Linux)
```bash
curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
```

## Установка yc (Windows)
- командная строка (cmd)
```cmd
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://storage.yandexcloud.net/yandexcloud-yc/install.ps1'))" && SET "PATH=%PATH%;%USERPROFILE%\yandex-cloud\bin"
```

- powershell
```cmd
iex (New-Object System.Net.WebClient).DownloadString('https://storage.yandexcloud.net/yandexcloud-yc/install.ps1')
```

В обоих случаях на вопрос
```pre
Add yc installation dir to your PATH? [Y/n]
```
Ввести Y

## Настройка параметров подключения
```bash
yc init
```

Идем по предложенной ссылке, получаем токен, вводим его  
выбираем облако ansvistunov  
и каталог unn-course  
Don't set default zone

Проверяем подключение
```bash
yc config list
ус compute instance list # покажет список виртуальных машин в выбранном каталоге
```

