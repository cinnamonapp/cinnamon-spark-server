class Notifier < ActionMailer::Base
  ADMIN_CONTACTS = ["alessio.santocs@gmail.com", "linnea@linneapassaler.it", "kaiser.stephanie@googlemail.com"]

  default from: "alessio.santocs@gmail.com"

  # Called when a new meal_record is uploaded
  def send_new_meal_record_uploaded_notification(user, meal_record)
    @user = user
    @meal_record = meal_record
    mail(to: ADMIN_CONTACTS, subject: "[Cinnamon] New meal record available for carbs evaluation!")
  end
end
