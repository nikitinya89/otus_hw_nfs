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

