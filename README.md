# AWS Custom Resources

This repo contains collection of custom resources for using in CloudFormation templates.

## Usage

1. Deploy particular stack from the collection into your account in region where you are going to use this custom resource.
1. Add custom resource with required configuration (see examples) into your target stack.

## Stacks

### AMI Info

`src/ami-info-stack.yaml`

This stack contains basic components for custom resource which allows you to
find the newest ami image by specified filter parameters. It contains lambda
function and a role for the lambda. To start you should deploy this stack to
the region and the account where you want to use it, then add custom resource
with desired search parameters into you stack:

```yaml
AMIInfo:
  Type: Custom::AMIInfo
  Properties:
    ServiceToken: !ImportValue Custom--AMIInfoFunction--Arn
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

`src/aurora-cluster-info-stack.yaml`

This stack contains basic components for custom resource which allows you to
retrieve information about rds cluster by specified pattern for
`DBClusterIdentifier`. It contains lambda function and a role for the lambda.
To start you should deploy this stack to the region and the account where you
want to use it, then add custom resource with desired search parameters into
you stack:

```yaml
AuroraClusterInfo:
  Type: Custom::AuroraClusterInfo
  Properties:
    ServiceToken: !ImportValue Custom--AuroraClusterInfoFunction--Arn
    Region: !Ref "AWS::Region"
    DBClusterIdentifierPattern: ^pre-stage-cluster.*
```

After that, you can get information as follows: `!GetAtt AuroraClusterInfo.Endpoint`.
Full list of available attributes see in [the docs for `describe_db_clusters`][3].

### Lambda Configurator

`src/lambda-configurator-stack.yaml`

This stack contains basic components for custom resource which allows you to
configure lambda concurrency limit during stack creation. It contains lambda
function and a role for the lambda. To start you should deploy this stack to
the region and the account where you want to use it, then add custom resource
with two parameters (`LambdaArn` and `ReservedConcurrentExecutions`) into you
stack:

```yaml
LambdaConfigurator:
  Type: Custom::LambdaConfigurator
  Properties:
    ServiceToken: !ImportValue Custom--LambdaConfiguratorFunction--Arn
    Region: !Ref "AWS::Region"
    LambdaArn: !GetAtt TargetLambda.Arn
    ReservedConcurrentExecutions: 10
```

[1]: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/create-reusable-transform-function-snippets-and-add-to-your-template-with-aws-include-transform.html
[2]: http://boto3.readthedocs.io/en/latest/reference/services/ec2.html#EC2.Client.describe_images
[3]: http://boto3.readthedocs.io/en/latest/reference/services/rds.html#RDS.Client.describe_db_clusters