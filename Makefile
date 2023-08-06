all: create_infra build_and_push deploy get_address

create_infra:
		@terraform -chdir=./terraform init
		@terraform -chdir=./terraform apply -auto-approve

build_and_push:
		@docker build -t europe-west1-docker.pkg.dev/wili-394920/wili-repository/times_app:0.0.1 ./app
		@docker push europe-west1-docker.pkg.dev/wili-394920/wili-repository/times_app:0.0.1

deploy:
		@gcloud container clusters get-credentials wili-gke-cluster --region europe-west1 --project wili-394920
		@helm package ./times-app
		@helm install times-app times-app-0.0.1.tgz

get_address:
		@sleep 120
		@kubectl get service/times-app

clean:
		@terraform -chdir=./terraform init
		@terraform -chdir=./terraform destroy -auto-approve