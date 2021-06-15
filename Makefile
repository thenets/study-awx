# Created from docs AWX Operation - Basic Install
# https://github.com/ansible/awx-operator#basic-install

# https://github.com/ansible/awx-operator/releases
AWX_VERSION=0.10.0

AWX_PROJECT_NAME=awx-demo

cluster-create:
	minikube start --addons=ingress --cpus=4 --cni=flannel --install-addons=true \
    	--kubernetes-version=stable --memory=6g

deploy:
	mkdir -p tmp
	curl -s --output tmp/aws-operator.yaml \
		https://raw.githubusercontent.com/ansible/awx-operator/$(AWX_VERSION)/deploy/awx-operator.yaml
	kubectl apply -f tmp/aws-operator.yaml

operator-logs:
	kubectl logs -f deployments/awx-operator

operator-check:
	kubectl logs -f deployments/awx-operator
	kubectl get svc -l "app.kubernetes.io/managed-by=awx-operator"

awx-get-url:
	@echo "# USER : admin"
	@echo "# PASS : $$(kubectl get secret $(AWX_PROJECT_NAME)-admin-password -o jsonpath="{.data.password}" | base64 --decode)"
	@echo "# HOST : $$(minikube service awx-demo-service --url)"
