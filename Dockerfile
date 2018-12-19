FROM alpine

ADD publish-chart.sh /usr/local/bin/publish-chart.sh
RUN chmod +x -R /usr/local/bin

CMD [ "/usr/local/bin/publish-chart.sh" ]
