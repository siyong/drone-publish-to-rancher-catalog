FROM alpine

ADD publish-chart.sh /usr/local/bin/
RUN chmod +x -R /usr/local/bin

CMD [ "/usr/local/bin/publish-chart.sh" ]
