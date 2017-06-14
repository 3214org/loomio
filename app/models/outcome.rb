class Outcome < ActiveRecord::Base
  extend  HasCustomFields
  include MakesAnnouncements
  include HasMentions
  set_custom_fields :calendar_invite, :event_location, :event_duration

  belongs_to :poll, required: true
  belongs_to :poll_option, required: false
  belongs_to :author, class_name: 'User', required: true
  has_one :discussion, through: :poll
  has_one :group, through: :discussion
  has_many :communities, through: :poll, class_name: "Communities::Base"
  has_many :stances, through: :poll

  has_many :events, -> { includes(:eventable) }, as: :eventable, dependent: :destroy

  delegate :title, to: :poll
  delegate :dates_as_options, to: :poll

  is_mentionable on: :statement

  validates :statement, presence: true, length: { maximum: Rails.application.secrets.max_message_length }
  validate :has_valid_poll_option

  def attendee_emails
     self.stances.join_participants.joins(:stance_choices)
    .where("stance_choices.poll_option_id": self.poll_option_id)
    .pluck(:"visitors.email", :"users.email").flatten.compact.uniq
  end

  def store_calendar_invite
    self.calendar_invite = CalendarInvite.new(self).encode
  end

  def has_valid_poll_option
    return if !self.poll_option_id || poll.poll_option_ids.include?(self.poll_option_id)
    errors.add(:poll_option_id, I18n.t(:"outcome.error.invalid_poll_option"))
  end
end
