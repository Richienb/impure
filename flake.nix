{
  outputs = { self, ... }: {
    templates = {
    	uv = {
        path = ./templates/uv;
      };
    	uv-cuda = {
        path = ./templates/uv-cuda;
      };
    };
  };
}
