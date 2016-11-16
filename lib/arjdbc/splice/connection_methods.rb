ArJdbc::ConnectionMethods.module_eval do
  def splice_connection(config)
    config[:adapter_spec] ||= ::ArJdbc::Derby

    return jndi_connection(config) if jndi_config?(config)

    begin
      require 'jdbc/splice'
      ::Jdbc::Splice.load_driver(:require) if defined?(::Jdbc::Splice.load_driver)
    rescue LoadError # assuming driver.jar is on the class-path
    end

    config[:url] ||= "jdbc:splice:#{config[:database]};create=true"
    config[:driver] ||= defined?(::Jdbc::Splice.driver_name) ?
      ::Jdbc::Splice.driver_name : 'com.splicemachine.db.jdbc.ClientDriver'

    embedded_driver(config)
  end
  alias_method :jdbcsplice_connection, :splice_connection
end
