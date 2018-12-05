# Initialize default data

class Defaults
  def perform
    make_default_remotes
  end

  private

  def make_default_remotes
    Zoldy.app.remotes_store.add(
      Remotes.new(
        Settings.default_remotes.map { |r| Remote.parse r }
      )
    )
  end
end
