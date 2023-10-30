require_relative '../controllers/articles'

class ArticleRoutes < Sinatra::Base
  use AuthMiddleware

  def initialize
    super
    @articleCtrl = ArticleController.new
  end

  before do
    content_type :json
  end

  get('/') do
    summary = @articleCtrl.get_batch

    return { articles: summary[:data] }.to_json if summary[:ok]

    return { msg: 'Could not get articles.' }.to_json
  end

  get('/:id') do
    article = @articleCtrl.get_article(params['id'])
    return { article: article[:data] }.to_json if article[:ok]

    return { msg: 'Could not get article.' }.to_json
  end

  post('/') do
    payload = JSON.parse(request.body.read)
    resp = @articleCtrl.create_article(payload)

    return { msg: 'Article created' }.to_json if resp[:ok]

    return { msg: resp[:msg] }.to_json
  end

  put('/:id') do
    payload = JSON.parse(request.body.read)
    resp = @articleCtrl.update_article(params['id'], payload)

    return { msg: 'Article updated' }.to_json if resp[:ok]

    return { msg: resp[:msg] }.to_json
  end

  delete('/:id') do
    resp = @articleCtrl.delete_article(params['id'])

    return { msg: 'Article deleted' }.to_json if resp[:ok]

    return { msg: 'Article does not exist' }.to_json
  end
end
