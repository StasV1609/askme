module ApplicationHelper
  def user_avatar(user)
    if user.avatar_url.present?
      user.avatar_url
    else
      asset_path 'avatar.png'
    end
  end

  def fa_icon(icon_class)
    content_tag 'span', '', class: "fa fa-#{icon_class}"
  end

  def sklonyator(amount, one, few, many)
  return many if (11..14).include?(amount % 100)

  remain = amount % 10

  return one if remain == 1
  return few if remain.between?(2,4)
  many
end
end
