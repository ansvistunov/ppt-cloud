yc iam service-account create --name <имя_сервисного_аккаунта>
yc iam service-account list
yc <service-name> <resource> add-access-binding <resource-name>|<resource-id> --role <role-id> --subject serviceAccount:<service-account-id>

+ <service-name> — название сервиса, на чей ресурс назначается роль, например resource-manager.
+ <resource> — категория ресурса, например cloud — для назначения роли на все облако или folder — для назначения роли на каталог.
+ <resource-name> — имя ресурса. Вы можете указать ресурс по имени или идентификатору (имя облака или каталога).
+ <resource-id> — идентификатор ресурса (идентификатор облака или каталога).
+ <role-id> — назначаемая роль, например resource-manager.clouds.owner.
+ <service-account-id> — идентификатор сервисного аккаунта, которому назначается роль.

Пример:
yc resource-manager folder add-access-binding **********9n9hi2qu --role editor --subject serviceAccount:**********qhi2qu

cp ./.terraformrc ~/.terraformrc


настройки подключения в файле main.tf

terraform init
