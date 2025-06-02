lambda = my_lambda_function

login:
	aws sso login --profile my-profile-dehn

apply:
	terraform apply --auto-approve

destroy:
	terraform destroy --auto-approve

zip:
	zip lambda_function.zip lambda_function.py

run:
	aws lambda invoke --function-name $(lambda) output.json
	jq '.' output.json

logs:
	aws logs tail "/aws/lambda/$(lambda)" --follow

update:
	aws lambda update-function-code --function-name $(lambda) --zip-file fileb://lambda_function.zip
