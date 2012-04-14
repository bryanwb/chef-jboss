class TestJBossStandalone < MiniTest::Chef::TestCase
  def home_dir
    "/usr/local/jboss"
  end

  def path
    "/usr/local/jboss-7.1.0"
  end
  
  def test_install_dir_exists
    assert File.exists?(path)
  end

  def test_homedir_symlink
    assert File.readlink(home_dir) == path
  end

  def test_jboss_unpacked
    assert File.stat(path).nlink > 2
  end

end
