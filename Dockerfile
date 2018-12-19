FROM jgreat/helm-with-plugins

ADD publish-chart.sh /bin/
RUN chmod +x /bin/publish-chart.sh
CMD [ "/bin/publish-chart.sh" ]
