ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Recent Competitions" do
          table_for Competition.order(starts_on: :desc).limit(10) do
            column(:name) { |c| link_to c.name, admin_competition_path(c) }
            column :location
            column :discipline
            column :status
            column :starts_on
          end
        end
      end

      column do
        panel "Stats" do
          ul do
            li "Seasons: #{Season.count}"
            li "Competitions: #{Competition.count}"
            li "Athletes: #{Athlete.count}"
            li "Results: #{RoundResult.count}"
          end
        end

        panel "Upcoming Events" do
          table_for Competition.upcoming.order(:starts_on).limit(5) do
            column(:name) { |c| link_to c.name, admin_competition_path(c) }
            column :starts_on
          end
        end
      end
    end
  end
end
