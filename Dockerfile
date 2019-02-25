		#La imagen a usar
		FROM alpine:latest
		
		#Quien es el responsable
		MAINTAINER manuel
		
		#Ejecutar comandos dentro del contenedor
		RUN apk update
		RUN apk upgrade
		RUN apk add openssh bash nano sudo
		RUN addgroup student
		RUN adduser -s /bin/bash -G student student -D
		RUN echo student:student | chpasswd
		RUN sed -ri 's/(wheel:x:10:root)/\1,student/' /etc/group
		RUN sed -ri 's/# %wheel ALL=\(ALL\) ALL/%wheel ALL=\(ALL\) ALL/' /etc/sudoers
		RUN sed -ri 's;^root:x:0:0:root:/root:)/bin/ash;\1/bin/bash;' /etc/passwd
		RUN mkdir /var/run/sshd
		RUN sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
		
		#Declarando la variable KEYGEN para reutilizarla luego
		ENV KEYGEN="ssh-keygen -b 2048 -t rsa -f"
		
		#Usando la variable
		RUN $KEYGEN /etc/ssh/ssh_host_rsa_key -q -N ""
		RUN $KEYGEN /etc/ssh/ssh_host_dsa_key -q -N ""
		RUN $KEYGEN /etc/ssh/ssh_host_ecdsa_key -q -N ""
		RUN $KEYGEN /etc/ssh/ssh_host_ed25519_key -q -N ""
		
		#Diciendo a docker que se necesita exponer el puerto 22
		EXPOSE 22
		
		#Esta es la ultima linea en la declaracion de un fichero de Docker
		#No puede haber dos lineas CMD en el mismo fichero.
		CMD ["/usr/sbin/sshd","-D"]
