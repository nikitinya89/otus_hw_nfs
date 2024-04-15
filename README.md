# Otus Homework 8. NFS

### Домашнее задание
NFS

**Цель:**  
Развернуть сервис NFS и подключить к нему клиента.

**Задание**
- vagrant up должен поднимать 2 виртуалки: сервер и клиент
- на сервер должна быть расшарена директория
- на клиента она должна автоматически монтироваться при старте (fstab или autofs)
- в шаре должна быть папка upload с правами на запись
- требования для NFS: NFSv3 по UDP, включенный firewall

## Выполнение
Домашнее задание выполнялось для ВМ с ОС **Centos 7**. Бокс был загружен из Vagrant Cloud, соотвественно, выполнение команды **vagrant up** должно осуществляться при ***подключенном VPN-соединении***. Задание выполняется с помощью bash скриптов *nfss_script.sh* для сервера и *nfsc_script.sh* для клиента, добавленных в *Vagrantfile*.

### nfss_script.sh
- устанавливает пакет *nfs-utils*
- запускает и добавляет в автозагрузку службы **nfs** и **firewalld**
- добавляет разрешающие правила файерволла для служб *nfs v3*, *mountd* и *rpc-bind*
- создает папку для *nfs*
- создает необходимую структуру в файле */etc/exports* и экпортирует ее

### nfsc_script.sh
- устанавливает пакет *nfs-utils*
- запускает и добавляет в автозагрузку службу **firewalld**
- добавляет разрешающие правила файерволла для служб *nfs v3*, *mountd* и *rpc-bind*
- добавляет конфигурацию для автомонтирования папки */mnt/* в  */etc/exports*

## Проверка работоспособности

Проверяем наличие разрешающихз правил для файерволла на сервере и клиенте:
```bash
[vagrant@nfss ~]$ sudo firewall-cmd --zone=public --list-services
dhcpv6-client mountd nfs3 rpc-bind ssh
[vagrant@nfss ~]$ sudo firewall-cmd --zone=public --list-services --permanent
dhcpv6-client mountd nfs3 rpc-bind ssh

###

[vagrant@nfsc ~]$ sudo firewall-cmd --zone=public --list-services
dhcpv6-client mountd nfs3 rpc-bind ssh
[vagrant@nfsc ~]$ sudo firewall-cmd --zone=public --list-services --permanent
dhcpv6-client mountd nfs3 rpc-bind ssh
[vagrant@nfsc ~]$

```

Заходим в каталог */srv/share/upload* на сервере и создаём тестовый файл `touch check_file`
На клиенте заходим в каталог */mnt/upload* и проверяем, ранее созданного файла:
```bash
[vagrant@nfsc ~]$ ls /mnt/upload/
check_file
```
На клиенте создаем тестовый файл `touch client_file`. Убеждаемся, что файл появился на сервере:
```bash
[vagrant@nfss ~]$ ls /srv/share/upload/
check_file  client_file
```
Перезагружаем клиент и сервер. Проверяем наличие ранее созданных файлов, статус служб nfs и firewalld.
На сервере проверяем работу RPC:
```bash
[vagrant@nfss ~]$ showmount -a 192.168.111.11
All mount points on 192.168.111.11:
192.168.111.12:/srv/share
```

На клиенте поверяем работу RPC и статус монитрования папки /mnt/:
```bash
[vagrant@nfsc upload]$ showmount -a 192.168.111.11
All mount points on 192.168.111.11:
192.168.111.12:/srv/share
[vagrant@nfsc upload]$ mount | grep mnt
systemd-1 on /mnt type autofs (rw,relatime,fd=21,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=10864)
192.168.111.11:/srv/share on /mnt type nfs (rw,relatime,vers=3,rsize=32768,wsize=32768,namlen=255,hard,proto=udp,timeo=11,retrans=3,sec=sys,mountaddr=192.168.111.11,mountvers=3,mountport=20048,mountproto=udp,local_lock=none,addr=192.168.111.11)
```
Содаем файл `touch final_check` и убеждаемся, что он появился и на клиенте и на сервере.


