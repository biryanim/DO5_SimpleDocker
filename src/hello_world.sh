#!bin/bash
gcc -Wall -Werror -Wextra hello_world.c -o hello_world -lfcgi 
spawn-fcgi -p 8080 hello_world 
nginx -g 'daemon off;'
