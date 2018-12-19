FROM alpine

ADD publish-chart.sh /bin/
RUN chmod +x -R /usr/local/bin

CMD [ "/bin/publish-chart.sh" ]
