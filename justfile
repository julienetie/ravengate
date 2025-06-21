default:
    echo 'Hello, world!'

install-nvm:
    scripts/install_nvm.sh

haraka-install:
    scripts/install_haraka.sh

ex:
    chmod +x scripts/*

haraka-init:
    rm -rf mail-stack/haraka/service 
    haraka -i mail-stack/haraka/service
    cd mail-stack/haraka/service && npm i

haraka-init-1:
    rm -rf mail-stack/haraka/service 
    haraka -i mail-stack/haraka/service
    rm -rf mail-stack/haraka/service/config/* mail-stack/haraka/service/plugins/* mail-stack/haraka/service/node_modules mail-stack/haraka/service/package.json
    cp -r mail-stack/haraka/custom_plugins/* mail-stack/haraka/service/plugins 
    cp -r mail-stack/haraka/default_configs/config_1/* mail-stack/haraka/service/config
    cp mail-stack/haraka/source_package.json mail-stack/haraka/service/package.json
    cd mail-stack/haraka/service && npm i

haraka-run:
    cd mail-stack/haraka/service && haraka -c . 

haraka-ssl:
    scripts/generate_ssl.sh

email-in:
    scripts/test_email_inbound.sh

install-nats-server:
    scripts/install_nats_server.sh

nats-jetstream-setup:
    scripts/nats_jetstream_setup.sh

nats-jetstream-enable-services:
    scripts/nats_jetstream_enable_services.sh

nats-cli-i:
    scripts/nats_cli_i.sh

nats-verify:
    scripts/nats_verify.sh
