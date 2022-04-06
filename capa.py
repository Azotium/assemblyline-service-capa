import subprocess

from assemblyline_v4_service.common.base import ServiceBase
from assemblyline_v4_service.common.result import Result, ResultSection


class Capa(ServiceBase):
    def __init__(self, config=None):
        super(Capa, self).__init__(config)

    def start(self):
        self.log.debug("Capa service started")

        def stop(self):
            self.log.debug("Capa service ended")

    def execute(self, request):
        # ==================================================================
        # Execute a request:
        #   Every time your service receives a new file to scan, the execute function is called
        #   This is where you should execute your processing code.
        #   For this example, we will only generate results ...
        # ==================================================================

        # 1. Create a result object where all the result sections will be saved to
        result = Result()
        file = request.file_path

        p1 = subprocess.run(
            "/opt/capa -r /opt/al_service/capa-rules -s /opt/al_service/capa/sigs -vv " + file,
            capture_output=True, text=True, shell=True, check=True).stdout

        # p1 = subprocess.run(
        #     "capa -r /home/infosec/git/capa-rules -s /home/infosec/git/capa/sigs -vv " + file,
        #     capture_output=True, text=True, shell=True, check=True).stdout

        # 2. Create a section to be displayed for this result
        text_section = ResultSection("CAPA Analysis output")

        # 2.1. Add lines to your section
        text_section.add_line(p1)

        # 3. Make sure you add your section to the result
        result.add_section(text_section)

        # 4. Wrap-up: Save your result object back into the request
        request.result = result
