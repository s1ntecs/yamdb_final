![example workflow](https://github.com/sintecs/yamdb_final/actions/workflows/yamdb_workflow/badge.svg)
# YaMDb api

YaTube API это RESTful API, позволяющий создавать и редактировать отзывы на различные произведения, оценивать их и
оставлять комментарии к отзывам. В основе проекта лежат Django и Django REST Framework.
Проект подготовлен для работы с docker.

## Особенности

- Пишите свои ревью и ставьте оценки произведениям.
- Авторизация происходит по токену. 
- Токен можно получить введя код подтверждения из электронного письма.
- При просмотре информации о каком-либо произведении будет выведена его средняя оценка.
- Для авторизованных пользователей присутствует возможность комментировать отзывы.

## Технологии

- [Django](https://github.com/django/django) - фреймворк, который включает в себя все необходимое для быстрой разработки
  различных веб-сервисовю
- [Django REST Framework](https://www.django-rest-framework.org/) - фреймворк, расширяющий возможности Django и
  позволяющий быстро писать RESTful API для Django-проектов.
- [Docker](https://docs.docker.com/) - это  приложение для вашей среды Python, Wnidows, которое позволяет создавать контейнерные приложения и микросервисы и совместно использовать их.
Конечно же YaTube API это ПО с открытым исходным кодом и [публичным репозиторием](https://github.com/krapiwin/api_yamdb)
на GitHub и (https://hub.docker.com/repository/docker/sintecs/yamdb/) на DockerHub.
- [GitHub Actions](https://github.com/features/actions) - это облачный сервис, инструмент для автоматизации процессов тестирования и деплоя проектов. Он служит тестовой площадкой, на которой можно запускать и тестировать проекты в изолированном окружении.

## Начало работы
Клонировать GitHub репозиторий на ваш локальный компьютер:

```
git clone https://github.com/s1ntecs/infra_sp2.git

```

```
Необходимо создать файл переменных окружения .env без переменных окружения наш сервис не будет работать.
Образец заполнения файла можете посмотреть в example.env в директории infra.

```
### Как запустить проект на вашем сервере Linux:
Войдите в ваш Сервер:

Остановите службу nginx:

```
 sudo systemctl stop nginx
```
Установите docker:

```
 sudo apt install docker.io
```

Установите docker-compose https://docs.docker.com/compose/install/

Скопируйте файлы infra/docker-compose.yaml и infra/nginx/default.conf с локального репозитория на ваш сервер в home/<ваш_username>/docker-compose.yaml и home/<ваш_username>/nginx/default.conf соответственно.

## Добавьте в Secrets GitHub Actions переменные окружения для работы базы данных.
    DB_ENGINE - указываем, что работаем с postgresql
    DB_HOST - имя базы данных
    DB_NAME - логин для подключения к базе данных
    DB_PORT - порт для подключения к БД
    DOCKER_PASSWORD - Пароль от Docker
    DOCKER_USERNAME - Логин от аккакнта Docker
    HOST - адрес вашего сервера
    PASSPHRASE - контрольная фраза для входа в сервер
    POSTGRES_PASSWORD - пароль Posgress
    POSTGRES_USER - логин Posgress
    SSH_KEY - ssh ключь для входа в сервер можете получить введя в консоль: cat ~/.ssh/id_rsa
    TELEGRAM_TO - Телеграм id аккаунта в телеграмм
    TELEGRAM_TOKEN - Телеграм токен
    USER - логин для входа на ваш сервер

Склонируйте Докер контейнер:

```
sudo docker pull sintecs/yamdb_final:latest

```
Запустите Docker-compose:

```
sudo docker compose up -d --build

```

Теперь в контейнере web нужно выполнить миграции, создать суперпользователя и собрать статику:

```
docker-compose exec web python manage.py migrate

```
Создадим суперпользователя:

```
docker-compose exec web python manage.py createsuperuser

```

Соберем Статику:

```
docker-compose exec web python manage.py collectstatic --no-input

```


API будет доступен по адресу:

```
http://localhost/api/v1/

```

## Пользовательские роли
```Аноним — может просматривать описания произведений, читать отзывы и комментарии.```

```Аутентифицированный пользователь (user) — может, как и Аноним, читать всё, дополнительно он может публиковать отзывы и ставить оценку произведениям (фильмам/книгам/песенкам), может комментировать чужие отзывы;может редактировать и удалять свои отзывы и комментарии. Эта роль присваивается по умолчанию каждому новому пользователю.```

```Модератор (moderator) — те же права, что и у Аутентифицированного пользователя плюс право удалять любые отзывы и комментарии.```

```Администратор (admin) — полные права на управление всем контентом проекта. Может создавать и удалять произведения, категории и жанры. Может назначать роли пользователям.```

```Суперюзер Django — обладет правами администратора (admin)```

## Примеры работы с API:

Получение списка всех категорий и создание новой(доступно только для роли 'Administrator') происходит на эндпоинте:

```sh
http://localhost/api/v1/categories/
```

Пример ответа при GET запросе с параметрами offset и count:
```
[
  {
    "count": 0,
    "next": "string",
    "previous": "string",
    "results": [
      {
        "name": "string",
        "slug": "string"
      }
    ]
  }
]

```

Редактирование категорий запрещено. Удаление категории происходит на эндпоинте:

```sh
http://localhost/api/v1/categories/{slug}/
```


Получение списка жанров и создание нового(доступно только для роли 'Administrator') происходит на эндпоинте:

```sh
http://localhost/api/v1/genres/
```
Пример ответа:
```
[
  {
    "count": 0,
    "next": "string",
    "previous": "string",
    "results": [
      {
        "name": "string",
        "slug": "string"
      }
    ]
  }
]
```

Получение конкретного жанра, а так же его редактирование запрещено. А удаление происходит на эндпоинте:

```sh
http://localhost/api/v1/genres/{slug}/
```

Получение списка произведений и создание нового происходит на эндпоинте:

```sh
http://localhost/api/v1/titles/
```

Пример ответа:
```
[
  {
    "id": 0,
    "title": "string",
    "slug": "string",
    "description": "string"
  }
]
```

Для конкретной группы доступен только метод GET(id - первичный ключ таблицы Groups) на эндпоинте:

```sh
http://localhost/api/v1/groups/{id}/
```

Пример ответа:
```
{
  "id": 0,
  "title": "string",
  "slug": "string",
  "description": "string"
}
```

Следующий эндпоинт возвращает все подписки пользователя, сделавшего запрос. Анонимные запросы запрещены (метод GET):

```sh
http://localhost/api/v1/follow/
```

Пример ответа:
```
[
  {
    "user": "string",
    "following": "string"
  }
]
```

Подписка пользователя от имени которого сделан запрос на пользователя переданного в теле запроса. Анонимные запросы
запрещены (метод POST):

```sh
http://localhost/api/v1/follow/
```

Создание, обновление и верификация токена происходит на следущих эндпоинтах:

```sh
http://localhost/api/v1/titles/{title_id}/reviews/{review_id}/comments/
```

Пример ответа:
```
[
  {
    "count": 0,
    "next": "string",
    "previous": "string",
    "results": [
      {
        "id": 0,
        "text": "string",
        "author": "string",
        "pub_date": "2019-08-24T14:15:22Z"
      }
    ]
  }
]
```

Получение конкретного комментария, а так же его редактирование и удаление
(доступно только для автора комментария, модератора или администратора) происходит на эндпоинте:

```sh
http://localhost/api/v1/titles/{title_id}/reviews/{review_id}/comments/{comment_id}/
```
Пример ответа: 
```
{
  "id": 0,
  "text": "string",
  "author": "string",
  "pub_date": "2019-08-24T14:15:22Z"
}
```

Регистрация пользователя и получение jwt токена происходит на следующих эндпоинтах:

```sh
http://localhost/api/v1/auth/signup/
http://localhost/api/v1/auth/token/
```

## Лицензия

**MIT**

**Free Software, Hell Yeah!**
