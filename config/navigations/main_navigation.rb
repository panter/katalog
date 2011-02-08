# Configures your navigations
SimpleNavigation::Configuration.run do |navigation|  
  # Define the primary navigations
  navigation.items do |primary|
    # doku zug navigations
    primary.item :nav_dossiers, t('katalog.main_navigation.dossiers'), dossiers_path, :highlights_on => /\/dossiers/ do |dossier|
      dossier.item :index, t('katalog.main_navigation.dossier_index'), dossiers_path
      dossier.item :search, t('katalog.main_navigation.search'), search_dossiers_path
    end
    primary.item :key_words, t('controllers.index.keyword'), keywords_path

    if user_signed_in?
      primary.item :adminstration, t('katalog.main_navigation.administration'), locations_path do |administration|
        administration.item :locations, t('katalog.main_navigation.locations'), locations_path
        administration.item :dossier_types, t('katalog.main_navigation.container_types'), container_types_path
        administration.item :users, t('katalog.main_navigation.users'), users_path, :if => Proc.new { can?(:new, User) }
        administration.item :edit_dossier_years, t('katalog.main_navigation.edit_year'), edit_report_dossiers_path, :if => Proc.new { can?(:update, Dossier) }
        administration.item :new_dossier, t('katalog.main_navigation.new_dossier'), new_dossier_path, :highlights_on => /\/dossiers\/new/, :if => Proc.new { can?(:new, Dossier) }
        administration.item :new_title, t('katalog.main_navigation.new_title'), new_topic_path, :if => Proc.new { can?(:new, Topic) }
        if current_user.role?'admin'
          administration.item :versions_nav, t('katalog.main_navigation.changes'), versions_path, :highlights_on => /\/versions/
          administration.item :sphinx, t('katalog.main_navigation.search_admin'), exceptions_sphinx_admins_path do |sphinx|
            sphinx.item :exceptions, t('katalog.main_navigation.search_exceptions'), exceptions_sphinx_admins_path
            sphinx.item :word_forms, t('katalog.main_navigation.search_word_forms'), word_forms_sphinx_admins_path
          end
        end
      end
      primary.item :log_out, t('katalog.main_navigation.logout'), destroy_user_session_path
    else
      primary.item :log_in, t('katalog.main_navigation.login'), new_user_session_path
    end
  end
end
