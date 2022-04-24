FROM centos:latest
RUN dnf --disablerepo '*' --enablerepo=extras swap centos-linux-repos centos-stream-repos -y
RUN dnf distro-sync -y
RUN yum update -y 
RUN yum install httpd -y
COPY index.html /var/www/html/
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
EXPOSE 80