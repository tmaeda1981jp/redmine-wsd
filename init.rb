Redmine::Plugin.register :redmine_wsd do
  name 'Redmine Sequencedialog Macros plugin'
  author 'tmaeda1981jp'
  description 'Redmine wiki page macros for www.websequencediagrams.com'
  version '0.0.1'
  url 'https://github.com/tmaeda1981jp/redmine-wsd'
  author_url 'https://github.com/tmaeda1981jp'
end

Redmine::WikiFormatting::Macros.register do
  desc 'Redmine wiki page macros for www.websequencediagrams.com'
  macro :wsd do |obj, args, text|
    raise 'Invalid arguments' if args.length > 2
    response = Net::HTTP.post_form(
      URI.parse('http://www.websequencediagrams.com/index.php'),
      'style' => args[1] || 'patent',
      'message' => text)
    result = YAML.load(response.body)
    raise result['errors'].join(',') if result['errors'].any?

    return image_tag(
      "http://www.websequencediagrams.com/#{result['img']}",
      :width => args[0] || '480px')

  end
end
