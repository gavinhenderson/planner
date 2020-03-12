class WorkshopInvitationMailer < ActionMailer::Base
  include EmailHeaderHelper
  include ApplicationHelper

  helper ApplicationHelper

  def invite_student(workshop, member, invitation)
    @workshop = WorkshopPresenter.new(workshop)
    @member = member
    @invitation = invitation

    subject = t('mailer.workshop_invitation.invite_student.subject',
                date_time: humanize_date(@workshop.date_and_time, with_time: true))

    mail(mail_args(member, subject, 'no-reply@codebar.io'), &:html)
  end

  def invite_coach(workshop, member, invitation)
    @workshop = workshop
    @member = member
    @invitation = invitation

    subject = t('mailer.workshop_invitation.invite_coach.subject',
                date_time: humanize_date(@workshop.date_and_time, with_time: true))

    mail(mail_args(member, subject, 'no-reply@codebar.io'), &:html)
  end

  def attending(workshop, member, invitation, waiting_list = false)
    @workshop = WorkshopPresenter.new(workshop)
    @host_address = AddressPresenter.new(@workshop.host.address)
    @member = member
    @invitation = invitation
    @waiting_list = waiting_list

    subject = t('mailer.workshop_invitation.attending.subject',
                date_time: humanize_date(@workshop.date_and_time, with_time: true))

    attachments['codebar.ics'] = { mime_type: 'text/calendar',
                                   content: WorkshopCalendar.new(workshop).calendar.to_ical }

    mail(mail_args(member, subject, @workshop.chapter.email), &:html)
  end

  def change_of_details(workshop, sponsor, member, invitation, title = 'Change of details')
    @workshop = workshop
    @sponsor = sponsor
    @host_address = AddressPresenter.new(@workshop.host.address)
    @member = member
    @invitation = invitation

    subject = t('mailer.workshop_invitation.change_of_details.subject',
                title: title,
                workshop_title: @workshop.title,
                date_time: humanize_date(@workshop.date_and_time, with_time: true))

    mail(mail_args(member, subject, @workshop.chapter.email), &:html)
  end

  def attending_reminder(workshop, member, invitation)
    @workshop = WorkshopPresenter.new(workshop)
    @host_address = AddressPresenter.new(@workshop.host.address)
    @member = member
    @invitation = invitation

    subject = t('mailer.workshop_invitation.attending_reminder.subject',
                date_time: humanize_date(@workshop.date_and_time, with_time: true))
    mail(mail_args(member, subject, @workshop.chapter.email), &:html)
  end

  def waiting_list_reminder(workshop, member, invitation)
    @workshop = WorkshopPresenter.new(workshop)
    @host_address = AddressPresenter.new(@workshop.host.address)
    @member = member
    @invitation = invitation

    subject = t('mailer.workshop_invitation.waiting_list_reminder.subject',
                date_time: humanize_date(@workshop.date_and_time, with_time: true))
    mail(mail_args(member, subject, @workshop.chapter.email), &:html)
  end

  def notify_waiting_list(invitation)
    @workshop = invitation.workshop
    @host_address = AddressPresenter.new(@workshop.host.address)
    @member = invitation.member
    @invitation = invitation

    subject = t('mailer.workshop_invitation.notify_waiting_list.subject')

    mail(mail_args(@member, subject, @workshop.chapter.email), &:html)
  end

  private

  helper do
    def full_url_for(path)
      "#{@host}#{path}"
    end
  end
end
