output "load_balancer_arn" {
  value = aws_lb.production.arn
}

output "listener_arn" {
  value = aws_lb_listener.production_listener.arn
}

output "aws_lb_target_group" {
   value = aws_lb_target_group.production_tg.arn
 }

 output"security_group_id" {
   value = aws_security_group.lb.id
 }