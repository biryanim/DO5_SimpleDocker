# Simple Docker
## Part 1. Готовый докер
* Возьмем официальный докер-образ с **nginx** и выкачай его при помощи `docker pull`
    ![docker_pull_nginx](images/Part1/docker_pull_nginx.png)
* Проверим наличие докер-образа через `docker images`
    ![docker_images](images/Part1/docker_images.png)
* Запустим докер-образ через `docker run -d [image_id|repository]`
    ![docker_run_nginx](images/Part1/docker_run_nginx.png)
* Проверим, что образ запустился через `docker ps`
    ![docker_ps](images/Part1/docker_ps.png)
* Посмотрим информацию о контейнере через `docker inspect [container_id|container_name]`
    ![docker_inspect](images/Part1/docker_inspect.png)
* По выводу команды определим:
    * размер контейнера
        ![container_size](images/Part1/container_size.png)
    * список замапленных портов
        ![exposed_ports](images/Part1/exposed_ports.png)
    * ip контейнера
        ![container_ip](images/Part1/container_ip.png)
* Остановим докер контейнер через `docker stop [container_id|container_name]`
    ![docker_stop](images/Part1/docker_stop.png)
* Проверим, что контейнер остановился через `docker ps`
    ![docker_ps_after_stop](images/Part1/docker_stop_ps.png)
* Запустим докер с портами 80 и 443 в контейнере, замапленными на такие же порты на локальной машине
    ![run_nginx_with_ports](images/Part1/run_with_ports.png)
* Проверим, что в браузере по адресу *localhost:80* доступна стартовая страница **nginx**
    ![nginx_started_page](images/Part1/loclhost_nginx.png)
* Перезапустим докер контейнер через `docker restart [container_id|container_name]`
    ![docker_restart](images/Part1/docker_restart.png)
* Проверим, что контейнер запустился.
    ![docker_check](images/Part1/docker_check.png)

## Part 2. Операции с контейнером
* Прочитаем конфигурационный файл *nginx.conf* внутри докер контейнера через команду *exec*
    ![nginx_conf](images/Part2/nginx_conf_with_exec.png)
* Создадим на локальной машине файл *nginx.conf* и настроем в нем по пути */status* отдачу страницы статуса сервера **nginx**
    ![my_nginx_conf](images/Part2/my_nginx_conf.png)
* Скопируем созданный файл *nginx.conf* внутрь докер-образа через команду `docker cp`
    ![docker_cp_nginx_conf](images/Part2/docker_cp_nginx_conf.png)
* Перезапустим **nginx** внутри докер-образа через команду *exec*
    ![nginx_reload](images/Part2/nginx_reload.png)
* Проверим, что по адресу *localhost:80/status* отдается страничка со статусом сервера **nginx**
    ![localhost_statue](images/Part2/localhost_status.png)
* Экспортируем контейнер в файл *container.tar* через команду *export* и остановим контейнер
    ![docker_export](images/Part2/docker_export.png)
* Удалим образ через `docker rmi [image_id|repository]`, не удаляя перед этим контейнеры
    ![docker_rmi](images/Part2/docker_rmi.png)
* Удалим остановленный контейнер
    ![docker_rm](images/Part2/docker_rm.png)
* Импортируем контейнер обратно через команду *import*
    ![docker_import](images/Part2/docker_import.png)
* Запустим импортированный контейнер и проверим, что по адресу *localhost:80/status* отдается страничка со статусом сервера **nginx**.
    ![docker_run](images/Part2/docker_run.png)
    ![localhost_status_2](images/Part2/loclalhost_status_2.png)

## Part 3. Мини веб-сервер
* Напишем мини-сервер на **C** и **FastCgi**, который будет возвращать простейшую страничку с надписью `Hello World!`
    ![hello_world](images/Part3/hello_world.png)
* Запустим написанный мини-сервер через *spawn-fcgi* на порту 8080
    ![spawn_fcgi](images/Part3/spawn_fcgi.png)
* Напишем свой *nginx.conf*, который будет проксировать все запросы с 81 порта на *127.0.0.1:8080*. 
    ![sudo_nginx_conf](images/Part3/sudo_nginx_conf.png)
* Перезапустим nginx с помощью команды `sudo nginx -s reload` и проверим, что в браузере по *localhost:81* отдается написанная тобой страничка
    ![localhost_81](images/Part3/localhost_81.png)
* Положим файл *nginx.conf* по пути *./nginx/nginx.conf* (это понадобится позже) 

## Part 4. Свой докер

* Напишем свой докер-образ, который:
    1) собирает исходники мини сервера на FastCgi из Части 3;
    2) запускает его на 8080 порту;
    3) копирует внутрь образа написанный ./nginx/nginx.conf;
    4) запускает nginx.
    ![dockerfile](images/Part4/dockerfile.png)
    Скрипт компилирующий мини-сервер на **C** и запускающий этот сервер через *spawn-fcgi* на порту 8080
    ![hello_world_sh](images/Part4/hello_worls_sh.png)
* Соберем написанный докер-образ через docker build при этом указав имя и тег и
проверим через docker images, что все собралось корректно
    ![docker_build](images/Part4/docker_build.png)
* Запустим собранный докер-образ с маппингом 81 порта на 80 на локальной машине и маппингом папки ./nginx внутрь контейнера по адресу, где лежат конфигурационные файлы nginx'а (см. Часть 2)
    ![docker_run_hw_server](images/Part4/docker_run_hw_server.png)
* Проверим, что по localhost:80 доступна страничка написанного мини сервера
    ![hw_lhost_80_1](images/Part4/lhost_80_hw_server.png)
    ![hw_lhost_80_2](images/Part4/lhost_80_hw_server2.png)
* Допишем в ./nginx/nginx.conf проксирование странички /status, по которой надо отдавать статус сервера nginx
    ![nginx_conf_location_status](images/Part4/nginx_conf_location_status.png)
* Перезапустим докер-образ и проверим, что теперь по *localhost:80/status* отдается страничка со статусом **nginx**
    ![status_hw_1](images/Part4/status_hw_1.png)
    ![status_hw_2](images/Part4/status_hw_2.png)

## Part 5. **Dockle**
* Просканируем образ из предыдущего задания через `dockle [image_id|repository]`
    ![dockle](images/Part5/dockle.png)
* Исправим образ так, чтобы при проверке через **dockle** не было ошибок и предупреждений
    ![dockle_finish](images/Part5/dockle_finish.png)
    ![dockle_dockerfile](images/Part5/dockerfile_dockle.png)

## Part 6. Базовый **Docker Compose**

* Напишем файл *docker-compose.yml*, с помощью которого:
     1) Поднимем докер-контейнер из [Части 5](#part-5-инструмент-dockle) _(он должен работать в локальной сети, т. е. не нужно использовать инструкцию **EXPOSE** и мапить порты на локальную машину)_.
     2) Поднимем докер-контейнер с **nginx**, который будет проксировать все запросы с 8080 порта на 81 порт первого контейнера. Для проксирования создадим config, который примонтируем в yml файле
        ![proxy_nginx_conf](images/Part6/proxy_nginx_conf.png)
     3) Замапим 8080 порт второго контейнера на 80 порт локальной машины.
![docker_compose](images/Part6/docker_compose.png)

* Проверим, что нет запущенных контейнеров
    ![docker_compose_1](images/Part6/docker_ps_a.png)

* Соберем и запустим проект с помощью команд `docker-compose build` и `docker-compose up` и проверим, что в браузере по *localhost:80* отдается написанная тобой страничка, как и ранее.
    ![docker_compose_up](images/Part6/docker_compose_up.png)