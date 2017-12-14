# AWS Custom Resources

This repo contains collection of custom resources for CloudFormation templates.

## Usage

1. Add content of particular snippet into your CloudFormation template:
    - Copy it into your template.
    - Or put snippet into S3 bucket and [include][1] it into your template.
1. Add custom resource with required configuration (see examples).

## Snippets

### AMI Info

`src/ami-info.yaml`

This snippet allows you to find the latest ami image by specified filter
parameters. It contains lambda function and a role for the lambda. To do the
stuff you should include this snippet into your cloudformation template's
'Resources' section and add custom resource with desired search parameters:

```yaml
AMIInfo:
  Type: Custom::AMIInfo
  Properties:
    ServiceToken: !GetAtt AMIInfoFunction.Arn
    Region: !Ref "AWS::Region"
    # 'DescribeParameters' contains named arguments for ec2.describe_images function
    DescribeParameters:
      Filters:
        - Name: name
          Values:
            - ami-name*
```

After that, you can get image id as follows: `!GetAtt AMIInfo.ImageId`.
Full list of available attributes see in [the docs for `describe_images`][2].

### Aurora Cluster Info

`src/aurora-cluster-info.yaml`

This snippet allows you to retrieve information about rds cluster by
specified pattern for `DBClusterIdentifier`. The snippet contains lambda
function and a role for the lambda. To do the stuff you should include this
snippet into your cloudformation template's 'Resources' section and add
custom resource with desired pattern:

```yaml
AuroraClusterInfo:
  Type: Custom::AuroraClusterInfo
  Properties:
    ServiceToken: !GetAtt AuroraClusterInfoFunction.Arn
    Region: !Ref "AWS::Region"
    DBClusterIdentifierPattern: ^pre-stage-cluster.*
```

After that, you can get information as follows: `!GetAtt AMIInfo.Endpoint`.
Full list of available attributes see in [the docs for `describe_db_clusters`][3].

### Lambda Configurator

`src/lambda-configurator.yaml`

This snippet allows you to configure **lambda concurrency limit (only!)** during stack
creation. The snippet contains lambda function and a role for the lambda. To
do the stuff you should include this snippet into your cloudformation
template's 'Resources' section, add custom resource and specify two
parameters: `LambdaArn` and `ReservedConcurrentExecutions`. For example:

```yaml
LambdaConfigurator:
  Type: Custom::LambdaConfigurator
  Properties:
    ServiceToken: !GetAtt LambdaConfiguratorFunction.Arn
    Region: !Ref "AWS::Region"
    LambdaArn: !GetAtt TargetLambda.Arn
    ReservedConcurrentExecutions: 10
```

[1]: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/create-reusable-transform-function-snippets-and-add-to-your-template-with-aws-include-transform.html
[2]: http://boto3.readthedocs.io/en/latest/reference/services/ec2.html#EC2.Client.describe_images
[3]: http://boto3.readthedocs.io/en/latest/reference/services/rds.html#RDS.Client.describe_db_clusters