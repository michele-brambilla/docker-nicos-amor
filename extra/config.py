description = 'Generic configuration settings for AMOR'

group = 'configdata'

KAFKA_BROKERS = ['localhost:9092']

FILEWRITER_CMD_TOPIC = 'AMOR_filewriterCommands'
FILEWRITER_STATUS_TOPIC = 'AMOR_filewriterStatus'

FORWARDER_CMD_TOPIC = 'AMOR_forwarderCommands'
FORWARDER_STATUS_TOPIC = 'AMOR_forwarderStatus'

HISTOGRAM_MEMORY_URL = 'http://localhost:8080/admin'
HISTOGRAM_MEMORY_ENDIANESS = 'little'
