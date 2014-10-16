require 'mail'

mail = Mail.new
mail.from = "yunomu@gmail.com"
mail.to = "nomura_y@welmo.co.jp"
mail.subject = "おはよう"
mail.body = "明日は晴れるでしょう"
mail.smtp_envelope_from = "yunomu@gmail.com"
mail.smtp_envelope_to = "nomura_y@welmo.co.jp"

mail.delivery_method(:smtp,
  address: "smtp.sendgrid.net",
  port: 587,
  user_name: "sgbaggu4@kke.com",
  password: "we11motion"
)
mail.deliver
