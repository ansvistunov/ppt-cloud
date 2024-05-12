## Инсталляция
Для развертывания инфраструктуры на машине должны быть установлены:
+ yc
+ terraform
+ helm

terraform в россии не доступен, поэтому нужно использовать зеркала.
Для этого в домашнюю директорию пользователя нужно скопировать файл .terraformrc
```bash
cp ./.terraformrc ~/.terraformrc
```

### Настройка yandex cloud 
Для работы терраформ нужно создать сервисную учетку, дать ей нужные права 

```bash
yc iam service-account create --name sa-terraform
# смотрим список сервисных аккаунтов - нам нужен идентификатор для sa-terraform
yc iam service-account list
yc <service-name> <resource> add-access-binding <resource-name>|<resource-id> --role <role-id> --subject serviceAccount:<service-account-id>
```
+ <service-name> — название сервиса, на чей ресурс назначается роль, например resource-manager.
+ <resource> — категория ресурса, например cloud — для назначения роли на все облако или folder — для назначения роли на каталог.
+ <resource-name> — имя ресурса. Вы можете указать ресурс по имени или идентификатору (имя облака или каталога).
+ <resource-id> — идентификатор ресурса (идентификатор облака или каталога).
+ <role-id> — назначаемая роль, например resource-manager.clouds.owner.
+ <service-account-id> — идентификатор сервисного аккаунта, которому назначается роль.

Пример:
```bash
yc resource-manager folder add-access-binding **********9n9hi2qu --role editor --subject serviceAccount:**********qhi2qu
```
Создаем файл с ключом
```bash
yc iam key create \
--service-account-id <идентификатор_сервисного_аккаунта> \
--folder-name <имя_каталога_с_сервисным_аккаунтом> \
--output key.json
```
и создаем на его основе конфиг
```bash
yc config profile create sa-terraform
```
настраиваем конфиг на работу с каталогом и облаком и добавляем в него ключевой файл

```bash
yc config set service-account-key key.json
yc config set cloud-id <идентификатор_облака>
yc config set folder-id <идентификатор_каталога>
```

Теперь нам нужно настроить получение авторизационного токена для подключения к облаку. Настраиваем через переменную окружения:

```bash
export YC_TOKEN=$(yc iam create-token)
```

### Развертывание
В файле terraform.tfvars прописываем параметры развертывания. Важно указать параметры 
+ yc_cloud_id= идентификатор облака, в котором нужно развертывать инфраструктуру
+ yc_folder_id= идентификатор каталога, в котором нужно развертывать инфраструктуру

остальные можно оставить по умолчанию. Порт для postgresql менять нельзя - он не конфигурируется в яндексе.
после этого в директории infra запускаем
```bash
./setup.sh
```
### Удаление 
Переходим в директорию infra/terraform
Запускаем

```bash
terraform destroy
```
