using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using GOATBOOKING.Models;

namespace GOATBOOKING.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class HomestaysController : ControllerBase
    {
        private readonly MasterContext _context;

        public HomestaysController(MasterContext context)
        {
            _context = context; // _context này sẽ là kiểu để kết nối đến csdl
        }

        // GET: api/Homestays
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Homestay>>> GetHomestays()
        {
            return await _context.Homestays.ToListAsync();
        }
        

        //lấy ra những homestay chưa ai đặt - có userId = 0
        [HttpGet("Id0")]
        public async Task<ActionResult<IEnumerable<Homestay>>> GetHomestayshaveid0()
        {
            var query = _context.Homestays.AsQueryable();
            query = query.Where(h => h.UserId== 0);

            var homestays = await query.ToListAsync();

            if (homestays == null || homestays.Count == 0)
            {
                return NotFound("Hết homestay");
            }
            else
            {
                return Ok(homestays);
            }
        }
        // tìm kiếm theo thông tin nhập vào
        [HttpGet("search")] 
        
        public async Task<ActionResult<IEnumerable<Homestay>>> GetHomestays([FromQuery] string search)
        {                                                                   // FromQuery được lấy từ Urk 
            var query = _context.Homestays.AsQueryable(); 
            // lấy cơ sở dữ liệu ra

            if (!string.IsNullOrWhiteSpace(search)){
                query = query.Where(h => h.Name == search ||
                                         h.HomestayId.ToString().Contains(search)||
                                         h.Description.ToString().Contains(search)||
                                         h.Ward.ToString().Contains(search) ||
                                         h.District.ToString().Contains(search) ||
                                         h.Province.ToString().Contains(search) ||
                                         h.CreatedAt.ToString().Contains(search) ||
                                         h.UpdatedAt.ToString().Contains(search));
            }
            var homestays = await query.ToListAsync();

            if(homestays == null || homestays.Count == 0)
            {
                return NotFound();
            }
            else
            {
                return Ok(homestays);
            }
        }
        
        // GET: api/Homestays/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Homestay>> GetHomestay(long id)
        {
            var homestay = await _context.Homestays.FindAsync(id);

            if (homestay == null)
            {
                return NotFound();
            }

            return homestay;
        }
        // get => total homestay
        [HttpGet("totalHomestay")]
        public async Task<ActionResult<int>> GetTotalHomestays()
        {
            var totalHomestays = await _context.Homestays.CountAsync();
            return Ok(totalHomestays);
        }

        // PUT: api/Homestays/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutHomestay(long id, Homestay homestay)
        {
            if (id != homestay.HomestayId)
            {
                return BadRequest();
            }

            _context.Entry(homestay).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!HomestayExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Homestays
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Homestay>> PostHomestay(Homestay homestay)
        {
            
            //_context.Homestays.Add(homestay);
            //try
            //{
            //    await _context.SaveChangesAsync();
            //}
            //catch (DbUpdateConcurrencyException)
            //{
            //    if (HomestayExists(homestay.HomestayId))
            //    {
            //        return Conflict();
            //    }
            //    else
            //    {
            //        throw;
            //    }
            //}

            if(_context.Homestays.Any(h2 => h2.HomestayId == homestay.HomestayId))
            {
                return Conflict("Id homestay đã tồn tại");
            }

            homestay.CreatedAt = GetFormattedDateAsLong();
            homestay.UpdatedAt = GetFormattedDateAsLong();

            _context.Homestays.Add(homestay);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                return StatusCode(500, "lỗi khi thêm");

            }
            return CreatedAtAction("GetHomestay", new {id = homestay.HomestayId}, homestay );
        }
        private long GetFormattedDateAsLong()
        {
            var now = DateTime.Now;
            var formattedDate = now.ToString("yyyyMMdd"); // Chuyển thành chuỗi "YYYYMMDD"
            return long.Parse(formattedDate);  // Chuyển chuỗi thành long
        }

        // DELETE: api/Homestays/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteHomestay(long id)
        {
            //var homestay = await _context.Homestays.FindAsync(id);
            //if (homestay == null)
            //{
            //    return NotFound();
            //}

            //_context.Homestays.Remove(homestay);
            //await _context.SaveChangesAsync();

            //return NoContent();
            // phòng
            var roomsdelete = _context.Rooms.Where(r => r.HomestayId == id);
            _context.Rooms.RemoveRange(roomsdelete);
            await _context.SaveChangesAsync();

            // reviews
            var reviewdelete = _context.Reviews.Where(r => r.HomestayId == id);
            _context.Reviews.RemoveRange(reviewdelete);
            await _context.SaveChangesAsync();

            //photo
            var photodelete = _context.Photos.Where(r => r.HomestayId == id);
            _context.Photos.RemoveRange(photodelete);
            await _context.SaveChangesAsync();

            // service
            var servicedelete = _context.ServicesAdvantages.Where(r => r.HomestayId == id);
            _context.ServicesAdvantages.RemoveRange(servicedelete);
            await _context.SaveChangesAsync();


            var homestaysdelete = _context.Homestays.Where(h => h.HomestayId == id);
                _context.Homestays.RemoveRange(homestaysdelete);
                await _context.SaveChangesAsync();
            if(homestaysdelete == null)
            {
                return NotFound();
            }
            return NoContent();

        }

        private bool HomestayExists(long id)
        {
            return _context.Homestays.Any(e => e.HomestayId == id);
        }
    }
}
