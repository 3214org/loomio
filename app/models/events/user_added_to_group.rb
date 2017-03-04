class Events::UserAddedToGroup < Event

  def self.publish!(membership, inviter, message = nil)
    bulk_publish!(Array(membership), inviter, message).first
  end

  def self.bulk_publish!(memberships, inviter, message = nil)
    memberships.map do |membership|
      new(
        kind: 'user_added_to_group',
        user: inviter,
        eventable: membership,
        custom_fields: { message: message }
      )
    end.tap do |events|
      import(events)
      events.map { |event| EventBus.broadcast('user_added_to_group_event', event) }
    end
  end

  private

  def notification_actor
    eventable.inviter
  end
end
