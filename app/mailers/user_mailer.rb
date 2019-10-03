class UserMailer < ApplicationMailer

  def password_reset_email(user)
    @user = user
    mail(to: @user.email, subject: t('password_reset_email.subject'))
  end
end
