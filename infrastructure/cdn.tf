resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              =  "cloudresume001.s3.us-east-1.amazonaws.com"
    origin_id                =  "cloudresume001.s3.us-east-1.amazonaws.com"
    origin_access_control_id = "ETOT8VV66QC5V"
  }

    aliases = ["tavarishooks.com", "www.tavarishooks.com"]
is_ipv6_enabled = true
    default_root_object = "index.html"
    enabled             = true

  default_cache_behavior {
    cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    allowed_methods = ["GET","HEAD"]
    cached_methods = ["GET","HEAD"]
    target_origin_id = "cloudresume001.s3.us-east-1.amazonaws.com"
    viewer_protocol_policy = "redirect-to-https"  
    max_ttl = 0
    min_ttl = 0
    compress = true
  }

    restrictions {
      geo_restriction {
        restriction_type = "none"
      }
    }

  viewer_certificate {
    acm_certificate_arn = "arn:aws:acm:us-east-1:108737052649:certificate/4bcb364c-8657-4300-b0da-28e0b59de4a0"
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method = "sni-only"
  }
}

 
