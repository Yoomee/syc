module ApplicationControllerConcerns
  
  module Permissions
    
    def self.included(klass)
      klass.class_inheritable_accessor :ownership_model, :ownership_attribute
      klass.class_inheritable_hash :permission_levels
      klass.permission_levels = {}
      klass.extend Classmethods
      klass.helper_method :admin_logged_in?
    end

    module Classmethods 
      
      def admin_only(*actions)
        set_permission_levels(actions, :admin_only)
      end

      def admin_only_action?(action)
        permission_level(action) == :admin_only
      end

      def allowed_to?(url_options, member)
        case
          when member_only_action?(url_options[:action])
            !member.nil? && (member.not_primary_or_secondary? || primary_secondary_allowed(url_options))
          when admin_only_action?(url_options[:action])
            !member.nil? && member.is_admin?
          when owner_only_action?(url_options[:action])
            !member.nil? && (member.is_admin? || associated_model_instance(url_options[:id]).owned_by?(member)) && member.not_primary_or_secondary?
          else
            true
        end
      end

      def associated_model
        ownership_model || controller_name.singularize.camelcase.constantize
      end

      def associated_model_instance(id)
        id = id.id if !id.is_a?(Fixnum) && !id.is_a?(String)
        associated_model.find id
      end

      def member_only(*actions)
        set_permission_levels(actions, :member_only)
      end

      def member_only_action?(action)
        permission_level(action) == :member_only
      end
      
      def open_actions(*actions)
        clear_permission_levels(actions)
      end
      
      def open_action(action)
        clear_permission_levels([action])
      end

      def owner_only(*actions)
        set_permission_levels(actions, :owner_only)
      end
            
      def owner_only_action?(action)
        permission_level(action) == :owner_only
      end

      def permission_level(action)
        permission_levels[action.to_sym]
      end

      private
      
      def clear_permission_levels(actions)
        actions.flatten.each do |action|
          self.permission_levels.delete(action.to_sym)
        end
      end
      
      def set_permission_level(action, level)
        self.permission_levels[action.to_sym] = level.to_sym
      end
    
      def set_permission_levels(actions, level)
        actions.flatten.each do |action|
          set_permission_level(action, level)
        end
      end

      def primary_secondary_allowed(url_options)
        (url_options[:controller] == 'document_folders' && url_options[:action] == 'index') || (url_options[:controller] == 'document_folders' && url_options[:action] == 'show') || (url_options[:controller] == 'sessions' && url_options[:action] == 'destroy')
      end
    end
    
    def admin_logged_in?
      @logged_in_member && @logged_in_member.is_admin?
    end
    
    def admin_only_action?(action)
      self.class::admin_only_action?(action)
    end

    def allowed_to?(url_options, member)
      self.class::allowed_to?(url_options, member)
    end

    def owner_only_action?(action)
      self.class::owner_only_action?(action)
    end

    def member_only_action?(action)
      self.class::member_only_action?(action)
    end

  end
  
end