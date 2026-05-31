{
  outputs = { self, ... }: {
    templates = {
    	uv = {
        path = ./templates/uv;
      };
    	uv-cuda = {
        path = ./templates/uv-cuda;
      };
      bun = {
        path = ./templates/bun;
      };
      nodejs = {
        path = ./templates/nodejs;
      };
    };
  };
}
