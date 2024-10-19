### Deploying the modules

1. `cd` into the module's VPC folder (e.g. `cd terragrunt/live/non-prod/demo/us-east-1/project/k8sgpt/network/vpc/`).
2. Run `terragrunt plan` to see the changes you're about to apply.
3. If the plan looks good, run `terragrunt apply`.
4. `cd` into the module's EKS folder (e.g. `cd terragrunt/live/non-prod/demo/us-east-1/project/k8sgpt/eks/`).
5. Run `terragrunt plan` to see the changes you're about to apply.
6. If the plan looks good, run `terragrunt apply`.
7. `cd` into the module's EKS blueprints folder (e.g. `cd terragrunt/live/non-prod/demo/us-east-1/project/k8sgpt/eks-blueprints/`).
8. Run `terragrunt plan` to see the changes you're about to apply.
9. If the plan looks good, run `terragrunt apply`.

### Deploying k8sgpt operator and example files

1. Install CLI as explained [here](https://github.com/k8sgpt-ai/k8sgpt?tab=readme-ov-file#cli-installation)
```sh 
brew install k8sgpt
brew tap k8sgpt-ai/k8sgpt
brew install k8sgpt
```
2. Create a kubernetes secret as explained [here](https://github.com/k8sgpt-ai/k8sgpt-operator?tab=readme-ov-file#run-the-example)
```sh 
kubectl create secret generic k8sgpt-sample-secret --from-literal=openai-api-key=$OPENAI_TOKEN -n k8sgpt-operator-system
```
3. Apply the K8sGPT configuration object:
```sh 
kubectl apply -f kubernetes/k8sgpt/k8sgpt_config_object.yaml
```
4. Apply the examples
```sh 
kubectl apply -f kubernetes/k8sgpt/examples/
```
5. Follow [instructions](https://github.com/k8sgpt-ai/k8sgpt?tab=readme-ov-file#quick-start) to run k8sgpt commands to start analyzing the cluster:
```sh 
k8sgpt generate
k8sgpt auth add
k8sgpt analyze --explain
k8sgpt analyze --explain --with-doc
```