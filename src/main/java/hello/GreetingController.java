package hello;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

//import io.swagger.annotations.ApiOperation;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.view.RedirectView;
import org.springframework.beans.factory.annotation.Value;

@RestController
public class GreetingController {

    private static final String template = "Hello, %s!";
    private final Counter counter;

    @Value("${person.name}")
    private String person_name;

    public GreetingController() {
       counter = new Counter("greeting_counter");
    }

    @RequestMapping(value = "/", method = RequestMethod.GET)
    //@ApiOperation(value = "Generate a greeting for a given name")
    public Greeting sayHello() {
        counter.increment();
        return new Greeting((int)counter.count(),String.format(template, person_name));
    }

    @RequestMapping(value = "/liveliness", method = RequestMethod.GET)
    //@ApiOperation(value = "Generate a greeting for a given name")
    public Greeting checkLiveliness() {
        counter.increment();
        return new Greeting((int)counter.count(),String.format(template, person_name));
    }

    @RequestMapping(value = "/readiness", method = RequestMethod.GET)
    //@ApiOperation(value = "Generate a greeting for a given name")
    public Greeting checkReadiness() {
        counter.increment();
        return new Greeting((int)counter.count(),String.format(template, person_name));
    }

    @RequestMapping(value = "/v1/greeting" ,  method = RequestMethod.GET)
    //@ApiOperation(value = "Generate a greeting for a given name")
    public Greeting greeting(@RequestParam(value="name", defaultValue="World") String name) {
        counter.increment();
        return new Greeting((int)counter.count(),
                            String.format(template, name));
    }

    // @GetMapping("/")
    // public RedirectView index() {
    //     return new RedirectView("swagger-ui.html");
    // }


    @RequestMapping(value = "/v1/hostinfo",  method = RequestMethod.GET)
    //@ApiOperation(value = "List host name running the sample application.")
    public HostInfo hostinfo() throws IOException {
      return new HostInfo();
    }
    
    @RequestMapping(value = "/v1/envinfo" ,  method = RequestMethod.GET)
    //@ApiOperation(value = "Display environment variables.")
    public EnvInfo envinfo(@RequestParam(value="filter", defaultValue="*") String filter) throws IOException {
      return new EnvInfo(filter);
    }
    
}
