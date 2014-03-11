class ProjectSweeper < ActionController::Caching::Sweeper
  observe Project

  def after_save(*)
    expire_fragment(:portfolio_view)
  end
end
