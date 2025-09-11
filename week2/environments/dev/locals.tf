locals {
  owners      = var.business_divsion
  environment = var.environment
  name        = "${var.business_divsion}-${var.environment}"
  common_tags = {
    owners      = local.owners
    environment = local.environment
  }

  alb_target_groups = {
    # Target Group-1: mytg1
    mytg1 = {
      create_attachment = false
      name_prefix       = "mytg1-"
      protocol          = "HTTP"
      port              = 80
      target_type       = "instance"
      health_check = {
        path    = "/app1/index.html"
        matcher = "200-399"
      }
      tags = local.common_tags
    }
    # Target Group-2: mytg2
    mytg2 = {
      create_attachment = false
      name_prefix       = "mytg2-"
      protocol          = "HTTP"
      port              = 80
      target_type       = "instance"
      health_check = {
        path    = "/app2/index.html"
        matcher = "200-399"
      }
      tags = local.common_tags
    }
    # Target Group-3: mytg3
    mytg3 = {
      create_attachment = false
      name_prefix       = "mytg3-"
      protocol          = "HTTP"
      port              = 8080
      target_type       = "instance"
      health_check = {
        path    = "/login"
        matcher = "200-399"
      }
      tags = local.common_tags
    }
  }

  # -------------------------------------------------
  # ALB Listeners 설정 추가
  # -------------------------------------------------
  alb_listeners = {
    # Listener-1: HTTP to HTTPS Redirect
    my-http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
    # Listener-2: HTTPS Listener
    my-https-listener = {
      port       = 443
      protocol   = "HTTPS"
      ssl_policy = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
      # certificate_arn 값은 main.tf에서 동적으로 주입됩니다.

      # 기본 응답 (규칙에 해당하지 않는 경우)
      fixed_response = {
        content_type = "text/plain"
        message_body = "Fixed Static message - for Root Context"
        status_code  = "200"
      }

      # 경로 기반 라우팅 규칙
      rules = {
        myapp1-rule = {
          priority = 10
          actions = [{
            type               = "forward"
            target_group_index = 0 # mytg1
          }]
          conditions = [{
            path_pattern = { values = ["/app1*"] }
          }]
        }
        myapp2-rule = {
          priority = 20
          actions = [{
            type               = "forward"
            target_group_index = 1 # mytg2
          }]
          conditions = [{
            path_pattern = { values = ["/app2*"] }
          }]
        }
        myapp3-rule = {
          priority = 30
          actions = [{
            type               = "forward"
            target_group_index = 2 # mytg3
          }]
          conditions = [{
            path_pattern = { values = ["/*"] }
          }]
        }
      } # End of rules
    } # End of my-https-listener
  }   # End of alb_listeners
}