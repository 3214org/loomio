class Events::PollEdited < Event
  def self.publish!(version, actor, announcement = false)
    create(kind: "poll_edited",
           user: actor,
           eventable: version,
           announcement: announcement,
           discussion: version.item.discussion,
           created_at: version.created_at).tap { |e| EventBus.broadcast('poll_edited_event', e) }
  end

  def poll
    eventable.item
  end
end
