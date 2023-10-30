class ArticleController
  def create_article(article)
    article_exists = Article.where(title: article['title']).exists?(conditions = :none)

    return { ok: false, msg: 'Article with given title already exists' } if article_exists

    new_article = Article.create(title: article['title'], content: article['content'], created_at: Time.now)

    { ok: true, obj: article }
  end

  def update_article(id, new_data)
    article = Article.find(id)

    article.title = new_data['title']
    article.content = new_data['content']
    article.save

    { ok: true, obj: article }
  rescue ActiveRecord::RecordNotFound
    { ok: false, msg: 'Article could not be found' }
  end

  def get_article(id)
    res = Article.find(id)
    { ok: true, data: res }
  rescue ActiveRecord::RecordNotFound
    { ok: false, msg: 'Article not found' }
  end

  def delete_article(id)
    article = Article.find(id)
    article.destroy

    { ok: true, delete_count: 1 }
  rescue ActiveRecord::RecordNotFound
    { ok: false, msg: 'Article not found' }
  end

  def get_batch
    { ok: true, data: Article.all }
  end
end
