module "cdn" {
  source              = "terraform-aws-modules/cloudfront/aws"
  create_distribution = var.enable_cloudfront

  aliases = ["sandbox.skawstf.com"]

  comment             = "CloudFront for ezwel sandbox"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false


  # create_origin_access_identity = true
  # origin_access_identities = {
  #   s3_bucket_one = "My awesome CloudFront can access"
  # }

  origin = {
    alb-eks-ingress = {
      domain_name = "alb-ezwel-sandbox-ingress-970457490.us-west-2.elb.amazonaws.com"
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]

      }
    }

    # custom_header = [
    #   {
    #     name  = "X-Forwarded-Scheme"
    #     value = "https"
    #   },
    #   {
    #     name  = "X-Frame-Options"
    #     value = "SAMEORIGIN"
    #   }
    # ]

    # origin_shield = {
    #     enabled              = true
    #     origin_shield_region = "us-east-2"
    #   }
  }

  default_cache_behavior = {
    target_origin_id       = "alb-eks-ingress"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    # When defining a behavior in ordered_cache_behavior and default_cache_behavior with a cache policy, 
    # you must specify use_forwarded_values = false.
    use_forwarded_values = false

    # UseOriginCacheControlHeaders
    cache_policy_id = "83da9c7e-98b4-4e11-a168-04f0df8e2c65"
    # Managed-AllViewer
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
    # Managed-SecurityHeadersPolicy
    response_headers_policy_id = "67f7725c-6f97-4210-82d7-5512b31e9d03"

    compress = true
  }



  # ordered_cache_behavior = [
  #   {
  #     path_pattern           = "/static/*"
  #     target_origin_id       = "s3_one"
  #     viewer_protocol_policy = "redirect-to-https"

  #     allowed_methods = ["GET", "HEAD", "OPTIONS"]
  #     cached_methods  = ["GET", "HEAD"]
  #     compress        = true
  #     query_string    = true
  #   }
  # ]

  viewer_certificate = {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:533616270150:certificate/ea0f5caa-823b-44be-810d-3e4d18212433"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}
