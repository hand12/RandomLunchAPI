json.group do |group|
  group.id @group.id
  group.name @group.name
  json.members do
    json.array! @group.members do |member|
      json.id member.id
      json.name member.name
    end
  end
end
