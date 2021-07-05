#!/usr/bin/zsh

# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    setup.sh                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tcarlena <tcarlena@student.21-school.ru    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/10/20 23:29:41 by tcarlena          #+#    #+#              #
#    Updated: 2020/10/20 23:29:41 by tcarlena         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

PODS=(
		nginx		\
   		mysql		\
		wordpress
	)

function deploy()
{
	errlog=$(mktemp)
	kubectl get pods -l app=$1 2> $errlog
	docker build -t $1-image $2 ./srcs/$1
	kubectl apply -f ./srcs/$1/$1.yaml
	if [[ -s $errlog ]]; then
		echo "Pod started!"
	else
		kubectl delete pod -n default -l app=$1
		echo "Pod restarted!"
	fi
	rm -f $errlog
	return 0
}

#--------------- start minikube -----------------#
minikube start --driver=virtualbox											\
				--bootstrapper=kubeadm										\
				--extra-config=kubelet.authentication-token-webhook=true	
minikube addons enable metallb
minikube addons enable dashboard
minikube addons enable metrics-server

#------------------- Apply YAMLs ---------------------#

eval $(minikube docker-env)

kubectl apply -f ./srcs/metallb/metallb.yaml
deploy mysql
deploy phpmyadmin
deploy wordpress
deploy influxdb
deploy grafana
deploy nginx
deploy ftps

