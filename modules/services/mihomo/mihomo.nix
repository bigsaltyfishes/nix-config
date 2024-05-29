{ config, lib, pkgs, ... }:
let
  cfg = config.molyuu.system.services.mihomo;
in
{
  options.molyuu.system.services.mihomo = {
    enable = lib.mkEnableOption "Enable mihomo";
    webui = lib.mkOption {
      type = lib.types.package;
      default = config.nur.repos.guanran928.metacubexd;
    };
    subscription = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  imports = [
    ./subscription.nix
  ];

  config = lib.mkIf (cfg.enable && cfg.subscription != null) {
    services.mihomo = {
      enable = true;
      webui = cfg.webui;
      tunMode = true;
      configFile = pkgs.writeText "mihomo.yaml" ''
        ######### 锚点 start #######
        # 策略组相关
        pr: &pr {type: select, proxies: [默认,香港,台湾,日本,新加坡,美国,其它地区,全部节点,自动选择,直连]}

        #这里是订阅更新和延迟测试相关的
        p: &p {type: http, interval: 3600, health-check: {enable: true, url: https://www.gstatic.com/generate_204, interval: 300}}

        ######### 锚点 end #######

        # url 里填写自己的订阅,名称不能重复
        proxy-providers:
          provider1:
            <<: *p
            url: "${cfg.subscription}"

        ipv6: true
        allow-lan: true
        mixed-port: 7890
        unified-delay: false
        tcp-concurrent: true
        external-controller: 127.0.0.1:9090

        geodata-mode: true
        geox-url:
          geoip: "https://mirror.ghproxy.com/https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip-lite.dat"
          geosite: "https://mirror.ghproxy.com/https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat"
          mmdb: "https://mirror.ghproxy.com/https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/country-lite.mmdb"

        find-process-mode: strict
        global-client-fingerprint: chrome

        profile:
          store-selected: true
          store-fake-ip: true

        sniffer:
          enable: true
          sniff:
            HTTP:
              ports: [80, 8080-8880]
              override-destination: true
            TLS:
              ports: [443, 8443]
            QUIC:
              ports: [443, 8443]
          skip-domain:
            - "Mijia Cloud"

        tun:
          enable: false
          stack: mixed
          dns-hijack:
            - "any:53"
          auto-route: true
          auto-detect-interface: true

        dns:
          enable: true
          listen: '127.0.0.1:9053'
          default-nameserver: [192.168.1.1, 223.5.5.5, 223.6.6.6, 119.29.29.29]
          enhanced-mode: fake-ip
          nameserver: ['https://223.5.5.5/dns-query', 'https://223.6.6.6/dns-query', 'https://1.12.12.12/dns-query', 'https://120.53.53.53/dns-query']
          fallback: ['https://101.101.101.101/dns-query', 'https://101.102.103.104/dns-query', 'https://208.67.220.2/dns-query', 'https://208.67.222.2/dns-query', 'https://9.9.9.10/dns-query', 'https://149.112.112.10/dns-query', 'https://185.222.222.222/dns-query', 'https://45.11.45.11/dns-query', 'https://9ogv2ua3.dns.nextdns.io/dns-query', 'https://s5dz31kw.dns.nextdns.io/dns-query', 'https://3xf938p8.dns.nextdns.io/dns-query', 'https://obgdkl4l.dns.nextdns.io/dns-query']
          
        proxies:
        - name: "直连"
          type: direct
          udp: true
        proxy-groups:
          - {name: 默认, type: select, proxies: [自动选择, 直连, 香港, 台湾, 日本, 新加坡, 美国, 其它地区, 全部节点]}
          - {name: dns, type: select, proxies: [自动选择, 默认, 香港, 台湾, 日本, 新加坡, 美国, 其它地区, 全部节点]}
          - {name: Google, <<: *pr}
          - {name: Telegram, <<: *pr}
          - {name: Twitter, <<: *pr}
          - {name: Pixiv, <<: *pr}
          - {name: ehentai, <<: *pr}
          - {name: 哔哩哔哩, <<: *pr}
          - {name: 哔哩东南亚, <<: *pr}
          - {name: 巴哈姆特, <<: *pr}
          - {name: YouTube, <<: *pr}
          - {name: NETFLIX, <<: *pr}
          - {name: Spotify, <<: *pr}
          - {name: Github, <<: *pr}
          - {name: 国内, type: select, proxies: [直连, 默认, 香港, 台湾, 日本, 新加坡, 美国, 其它地区, 全部节点, 自动选择]}
          - {name: 其他, <<: *pr}

        #分隔,下面是地区分组
          - {name: 香港, type: select , include-all-providers: true, filter: "(?i)港|hk|hongkong|hong kong"}
          - {name: 台湾, type: select , include-all-providers: true, filter: "(?i)台|tw|taiwan"}
          - {name: 日本, type: select , include-all-providers: true, filter: "(?i)日|jp|japan"}
          - {name: 美国, type: select , include-all-providers: true, filter: "(?i)美|us|unitedstates|united states"}
          - {name: 新加坡, type: select , include-all-providers: true, filter: "(?i)(新|sg|singapore)"}
          - {name: 其它地区, type: select , include-all-providers: true, filter: "(?i)^(?!.*(?:🇭🇰|🇯🇵|🇺🇸|🇸🇬|🇨🇳|港|hk|hongkong|台|tw|taiwan|日|jp|japan|新|sg|singapore|美|us|unitedstates)).*"}
          - {name: 全部节点, type: select , include-all-providers: true}
          - {name: 自动选择, type: url-test, include-all-providers: true, tolerance: 10}

        rules:
          - GEOIP,lan,直连,no-resolve
          - GEOSITE,biliintl,哔哩东南亚
          - GEOSITE,ehentai,ehentai
          - GEOSITE,github,Github
          - GEOSITE,twitter,Twitter
          - GEOSITE,youtube,YouTube
          - GEOSITE,google,Google
          - GEOSITE,telegram,Telegram
          - GEOSITE,netflix,NETFLIX
          - GEOSITE,bilibili,哔哩哔哩
          - GEOSITE,bahamut,巴哈姆特
          - GEOSITE,spotify,Spotify
          - GEOSITE,pixiv,Pixiv
          - GEOSITE,CN,国内
          - GEOSITE,geolocation-!cn,其他

          - GEOIP,google,Google
          - GEOIP,netflix,NETFLIX
          - GEOIP,telegram,Telegram
          - GEOIP,twitter,Twitter
          - GEOIP,CN,国内
          - MATCH,其他
      '';
    };
  };
}
