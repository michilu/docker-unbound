FROM michilu/fedora-zero
RUN yum install -y \
  unbound \
  && yum clean all
RUN sed -i -e "s/# interface: 0.0.0.0/interface: 0.0.0.0/" /etc/unbound/unbound.conf
RUN sed -i -e "s/# do-daemonize: yes/do-daemonize: no/" /etc/unbound/unbound.conf
EXPOSE 53/udp
ENV MOORAGE_SERVER_NAME moorage
ENV MOORAGE_SERVER_IP 192.168.59.103
ENV UNBOUND_ACCESS_CONTROL 192.168.0.0/16
CMD \
  unbound-control-setup ;\
  echo local-zone: \"$MOORAGE_SERVER_NAME\" redirect >> /etc/unbound/local.d/#MOORAGE_SERVER_NAME.conf ;\
  echo local-data: \"$MOORAGE_SERVER_NAME. IN A $MOORAGE_SERVER_IP\" >> /etc/unbound/local.d/$MOORAGE_SERVER_NAME.conf ;\
  echo access-control: $UNBOUND_ACCESS_CONTROL allow >> /etc/unbound/local.d/$MOORAGE_SERVER_NAME.conf ;\
  unbound-control start
